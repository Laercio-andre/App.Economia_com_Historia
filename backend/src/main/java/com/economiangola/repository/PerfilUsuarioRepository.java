// src/main/java/com/economiangola/repository/PerfilUsuarioRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.PerfilUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PerfilUsuarioRepository extends JpaRepository<PerfilUsuario, Long> {

    List<PerfilUsuario> findByUsuarioId(Long usuarioId);
}
