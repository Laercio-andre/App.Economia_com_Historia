// src/main/java/com/economiangola/repository/UsuarioConquistaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.UsuarioConquista;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioConquistaRepository extends JpaRepository<UsuarioConquista, Long> {

    List<UsuarioConquista> findByUsuarioId(Long usuarioId);

    boolean existsByUsuarioIdAndConquistaId(Long usuarioId, Long conquistaId);
}
