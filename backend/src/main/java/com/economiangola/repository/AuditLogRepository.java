// src/main/java/com/economiangola/repository/AuditLogRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    Page<AuditLog> findByUsuarioIdOrderByCriadoEmDesc(Long usuarioId, Pageable pageable);

    Page<AuditLog> findByEntidadeTipoAndEntidadeId(String entidadeTipo, Long entidadeId, Pageable pageable);
}
