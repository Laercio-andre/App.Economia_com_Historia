// src/main/java/com/economiangola/repository/ProgressoUsuarioRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ProgressoUsuario;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProgressoUsuarioRepository extends JpaRepository<ProgressoUsuario, Long> {

    Optional<ProgressoUsuario> findByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);

    Page<ProgressoUsuario> findByUsuarioId(Long usuarioId, Pageable pageable);
}
